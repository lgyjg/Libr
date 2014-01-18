class Api::V1::SessionsController < Devise::SessionsController

  def create
    warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    render :json => {:success => true}
  end


  def destroy
    sign_out(resource_name)
  end

  def failure
    render :json => {:success => false, :errors => ["Login Failed"]}
  end

end
