# frozen_string_literal: true

module Api
  module V1
    class DocsController < ApplicationController
      skip_before_action :authenticate_user!, only: [:index, :swagger_yaml]
      def index
        render html: swagger_ui_html.html_safe
      end

      def swagger_yaml
        send_file Rails.root.join('swagger', 'v1', 'swagger.yaml'), 
                  type: 'text/yaml', 
                  disposition: 'inline'
      end

      private

      def swagger_ui_html
        <<~HTML
          <!DOCTYPE html>
          <html>
          <head>
            <title>Shop API Documentation</title>
            <link rel="stylesheet" type="text/css" href="https://unpkg.com/swagger-ui-dist@4.15.5/swagger-ui.css" />
            <style>
              html { box-sizing: border-box; overflow: -moz-scrollbars-vertical; overflow-y: scroll; }
              *, *:before, *:after { box-sizing: inherit; }
              body { margin:0; background: #fafafa; }
            </style>
          </head>
          <body>
            <div id="swagger-ui"></div>
            <script src="https://unpkg.com/swagger-ui-dist@4.15.5/swagger-ui-bundle.js"></script>
            <script src="https://unpkg.com/swagger-ui-dist@4.15.5/swagger-ui-standalone-preset.js"></script>
            <script>
              window.onload = function() {
                const ui = SwaggerUIBundle({
                  url: '/api/v1/docs/v1/swagger.yaml',
                  dom_id: '#swagger-ui',
                  deepLinking: true,
                  presets: [
                    SwaggerUIBundle.presets.apis,
                    SwaggerUIStandalonePreset
                  ],
                  plugins: [
                    SwaggerUIBundle.plugins.DownloadUrl
                  ],
                  layout: "StandaloneLayout"
                });
              };
            </script>
          </body>
          </html>
        HTML
      end
    end
  end
end
