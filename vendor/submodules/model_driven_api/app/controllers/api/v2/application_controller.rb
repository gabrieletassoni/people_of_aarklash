class Api::V2::ApplicationController < ActionController::API
  # Detect Locale from Accept-Language headers
  include HttpAcceptLanguage::AutoLocale
  # Actions will be authorized directly in the action
  include CanCan::ControllerAdditions
  include ::ApiExceptionManagement

  attr_accessor :current_user

  before_action :authenticate_request
  before_action :extract_model
  before_action :find_record, only: [:show, :destroy, :update, :patch]

  # GET :controller/
  def index
    authorize! :index, @model

    # Custom Action
    status, result, status_number = check_for_custom_action
    return render json: result, status: (status_number.presence || 200) if status == true

    # Normal Index Action with Ransack querying
    # Keeping this automation can be too dangerous and lead to unpredicted results
    # TODO: Remove it
    # @q = (@model.column_names.include?("user_id") ? @model.where(user_id: current_user.id) : @model).ransack(@query.presence|| params[:q])
    @q = @model.ransack(@query.presence || params[:q])
    @records_all = @q.result # (distinct: true) Removing, but I'm not sure, with it I cannot sort in postgres for associated records (throws an exception on misuse of sort with distinct)
    page = (@page.presence || params[:page])
    per = (@per.presence || params[:per])
    # pages_info = (@pages_info.presence || params[:pages_info])
    count = (@count.presence || params[:count])
    # Pagination
    @records = @records_all.page(page).per(per)
    # Content-Range: posts 0-4/27
    range_start = [(page.to_i - 1) * per.to_i, 0].max
    range_end = [0, page.to_i * per.to_i - 1].max
    response.set_header("Content-Range", "#{@model.table_name} #{range_start}-#{range_end}/#{@records.total_count}")

    # If there's the keyword pagination_info, then return a pagination info object
    # return render json: {count: @records_all.count,current_page_count: @records.count,next_page: @records.next_page,prev_page: @records.prev_page,is_first_page: @records.first_page?,is_last_page: @records.last_page?,is_out_of_range: @records.out_of_range?,pages_count: @records.total_pages,current_page_number: @records.current_page } if !pages_info.blank?

    # puts "ALL RECORDS FOUND: #{@records_all.inspect}"
    status = @records_all.blank? ? 404 : 200
    # puts "If it's asked for page number, then paginate"
    return render json: @records.as_json(json_attrs), status: status if !page.blank? # (@json_attrs || {})
    #puts "if you ask for count, then return a json object with just the number of objects"
    return render json: { count: @records_all.count } if !count.blank?
    #puts "Default"
    json_out = @records_all.as_json(json_attrs)
    #puts "JSON ATTRS: #{json_attrs}"
    #puts "JSON OUT: #{json_out}"
    render json: json_out, status: status #(@json_attrs || {})
  end

  def show
    authorize! :show, @record_id.presence || @model

    # Custom Show Action
    status, result, status_number = check_for_custom_action
    return render json: result, status: (status_number.presence || 200) if status == true

    # Normal Show
    result = @record.to_json(json_attrs)
    render json: result, status: 200
  end

  def create
    # Normal Create Action
    Rails.logger.debug("Creating a new record #{@record}")
    authorize! :create, @record.presence || @model
    # Custom Action
    status, result, status_number = check_for_custom_action
    return render json: result, status: (status_number.presence || 200) if status == true
    # Keeping this automation can be too dangerous and lead to unpredicted results
    # TODO: Remove it
    # @record.user_id = current_user.id if @model.column_names.include? "user_id"
    @record = @model.new(@body)
    @record.save!
    render json: @record.to_json(json_attrs), status: 201
  end

  def update
    authorize! :update, @record.presence || @model

    # Custom Action
    status, result, status_number = check_for_custom_action
    return render json: result, status: (status_number.presence || 200) if status == true

    # Normal Update Action
    # Rails 6 vs Rails 6.1
    @record.respond_to?("update_attributes!") ? @record.update_attributes!(@body) : @record.update!(@body)
    render json: @record.to_json(json_attrs), status: 200
  end

  # Define the path method as an alias to the update one, they are basically the same method
  alias_method :patch, :update

  def update_multi
    authorize! :update, @model
    ids = params[:ids].split(",")
    @model.where(id: ids).update!(@body)
    render json: ids.to_json, status: 200
  end

  def destroy
    authorize! :destroy, @record.presence || @model

    # Custom Action
    status, result, status_number = check_for_custom_action
    return render json: result, status: (status_number.presence || 200) if status == true

    # Normal Destroy Action
    return api_error(status: 500) unless @record.destroy
    head :ok
  end

  def destroy_multi
    authorize! :destroy, @model

    # Normal Destroy Action
    ids = params[:ids].split(",")
    @model.where(id: ids).destroy!(@body)
    render json: ids.to_json, status: 200
  end

  private

  ## CUSTOM ACTION
  # [GET|PUT|POST|DELETE] :controller?do=:custom_action
  # or
  # [GET|PUT|POST|DELETE] :controller/:id?do=:
  # or
  # [GET|PUT|POST|DELETE] :controller?do=:custom_action-token
  # or
  # [GET|PUT|POST|DELETE] :controller/:id?do=:custom_action-token
  # or
  # [GET|PUT|POST|DELETE] :controller/custom_action/:custom_action
  # or
  # [GET|PUT|POST|DELETE] :controller/custom_action/:custom_action/:id
  def check_for_custom_action

    custom_action, token = if !params[:do].blank?
      # This also responds to custom actions which have the bearer token in the custom action name. A workaround to remove for some IoT devices
      # Which don't support token in header or in querystring
      # This is for backward compatibility and in future it can ben removed
      params[:do].split("-")
    elsif request.url.include? "/custom_action/"
      [params[:action_name], nil]
    else
      # Not a custom action call
      false
    end
    return false unless custom_action
    # Poor man's solution to avoid the possibility to
    # call an unwanted method in the AR Model.

    # Adding some useful information to the params hash
    params[:request_url] = request.url
    params[:remote_ip] = request.remote_ip
    params[:request_verb] = request.request_method
    params[:token] = token.presence || bearer_token
    # The endpoint can be expressed in two ways:
    # 1. As a method in the model, with suffix custom_action_<custom_action>
    # 2. As a module instance method in the model, like Track::Endpoints.inventory
    # Example:
    # Endpoints::TestApi.new(:test, {request_verb: "POST", is_connected: "Uhhhh"}).result
    Rails.logger.debug("Checking for custom action #{custom_action} in #{@model}")
    if @model.respond_to?("custom_action_#{custom_action}")
      body, status = @model.send("custom_action_#{custom_action}", params)
    elsif ("Endpoints::#{@model}".constantize rescue false) && "Endpoints::#{@model}".constantize.instance_methods.include?(custom_action.to_sym)
      # Custom endpoint exists and can be called in the sub-modules form
      body, status = "Endpoints::#{@model}".constantize.new(custom_action, params).result
    else
      # Custom endpoint does not exist or cannot be called
      raise NoMethodError
    end
    
    return true, body.to_json(json_attrs), status
  end

  def bearer_token
    pattern = /^Bearer /
    header = request.headers["Authorization"]
    header.gsub(pattern, "") if header && header.match(pattern)
  end

  def class_exists?(class_name)
    klass = Module.const_get(class_name)
    return klass.is_a?(Class)
  rescue NameError
    return false
  end

  def authenticate_request
    @current_user = nil
    Settings.ns(:security).allowed_authorization_headers.split(",").each do |header|
      # puts "Found header #{header}: #{request.headers[header]}"
      check_authorization("Authorize#{header}".constantize.call(request))
    end

    check_authorization AuthorizeApiRequest.call(request) unless @current_user
    return unauthenticated!(OpenStruct.new({ message: @auth_errors })) unless @current_user

    current_user = @current_user
    params[:current_user_id] = @current_user.id
    # Now every time the user fires off a successful GET request,
    # a new token is generated and passed to them, and the clock resets.
    response.set_header("Token", JsonWebToken.encode(user_id: current_user.id))
  end

  def find_record
    record_id ||= (params[:path].split("/").second.to_i rescue nil)
    # Keeping this automation can be too dangerous and lead to unpredicted results
    # TODO: Remove it
    # @record = @model.column_names.include?("user_id") ? @model.where(id: (record_id.presence || @record_id.presence || params[:id]), user_id: current_user.id).first : @model.find((@record_id.presence || params[:id]))
    @record = @model.find((@record_id.presence || params[:id]))
    return not_found! if @record.blank?
  end

  def json_attrs
    # In order of importance: if you send the configuration via querystring you are ok
    # has precedence over if you have setup the json_attrs in the model concern
    from_params = params[:a].deep_symbolize_keys unless params[:a].blank?
    from_params = params[:json_attrs].deep_symbolize_keys unless params[:json_attrs].blank?
    from_params.presence || @json_attrs.presence || @model.json_attrs.presence || {} rescue {}
  end

  def extract_model
    # This method is only valid for ActiveRecords
    # For any other model-less controller, the actions must be
    # defined in the route, and must exist in the controller definition.
    # So, if it's not an activerecord, the find model makes no sense at all
    # thus must return 404.
    @model = (params[:ctrl].classify.constantize rescue params[:path].split("/").first.classify.constantize rescue controller_path.classify.constantize rescue controller_name.classify.constantize rescue nil)
    # Getting the body of the request if it exists, it's ok the singular or
    # plural form, this helps with automatic tests with Insomnia.
    @body = (params[@model.model_name.singular].presence || params[@model.model_name.route_key]) rescue params
    # Only ActiveRecords can have this model caputed
    return not_found! if (@model != TestApi && !@model.new.is_a?(ActiveRecord::Base) rescue false)
  end

  def check_authorization(cmd)
    if cmd.success?
      @current_user = cmd.result
    else
      @auth_errors = cmd.errors
    end
  end

  # Nullifying strong params for API
  def params
    request.parameters
  end
end
