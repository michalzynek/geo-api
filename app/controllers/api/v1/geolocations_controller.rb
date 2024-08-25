# frozen_string_literal: true

module API
  module V1
    class GeolocationsController < APIController
      before_action :check_ip_or_host_query, only: :index
      before_action :set_geolocation, only: %i[show destroy]

      def index
        query = Geolocation.where('ip = ? OR host = ?', params[:query], params[:query])
        pagy, records = pagy(query, jsonapi: true)
        serialized_records = API::V1::GeolocationSerializer.new(records).serializable_hash

        render json: serialized_records.merge({
                                                links: pagy_jsonapi_links(pagy)
                                              }).to_json
      end

      def show
        render json: API::V1::GeolocationSerializer.new(@geolocation).serializable_hash
      end

      def create
        geolocation = GeolocationCreatorService.new(ip_or_host).call

        render json: API::V1::GeolocationSerializer.new(geolocation).serializable_hash,
               status: :created
      rescue GeolocationProvider::BaseProvider::ServiceConnectionError => e
        render_error(
          e,
          { message: I18n.t('errors.service_failed_data_fetch') },
          :unprocessable_entity
        )
      end

      def destroy
        @geolocation.destroy!

        head :no_content
      end

      private

      def check_ip_or_host_query
        return if params[:query].present?

        render_error(
          ActionController::ParameterMissing,
          { message: 'Query parameter is required (should be IP or Host)' },
          :bad_request
        )
      end

      def set_geolocation
        @geolocation = Geolocation.find(params[:id])
      end

      def ip_or_host
        return geolocation_params[:host] if geolocation_params[:host].present?

        geolocation_params[:ip]
      end

      def geolocation_params
        params.require(:geolocation).permit(
          :ip, :host
        )
      end
    end
  end
end
