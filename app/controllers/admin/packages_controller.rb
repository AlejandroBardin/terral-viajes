class Admin::PackagesController < Admin::BaseController
  before_action :set_package, only: %i[ show edit update destroy ]

  # GET /admin/packages
  def index
    @packages = Package.all
  end

  # GET /admin/packages/1
  def show
  end

  # GET /admin/packages/new
  def new
    @package = Package.new
  end

  # GET /admin/packages/1/edit
  def edit
  end

  # POST /admin/packages
  def create
    @package = Package.new(package_params)

    if @package.save
      redirect_to admin_package_path(@package), notice: "Paquete creado exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /admin/packages/1
  def update
    if @package.update(package_params)
      # Si solo se actualizó featured, volver al index
      if params[:package].keys == [ "featured" ]
        redirect_to admin_packages_path, notice: "Estado de destacado actualizado."
      else
        redirect_to admin_package_path(@package), notice: "Paquete actualizado exitosamente."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /admin/packages/1
  def destroy
    @package.destroy!
    redirect_to admin_packages_path, status: :see_other, notice: "Paquete eliminado exitosamente."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_package
      @package = Package.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def package_params
      params.expect(package: [
        :title, :price, :stars, :duration, :dates, :regime, :featured, :description,
        :main_image, :keyword, :gpt_prompt, :start_date, :end_date,
        :min_passengers, :max_passengers, :min_age, :max_age, :kids_friendly,
        { gallery_images: [], ideal_profile: [], extras: {}, trip_purpose: [], experience_type: [],
          questions_attributes: [ :id, :name, :answer, :kind, :score, :enabled, :_destroy ] }
      ])
    end
end
