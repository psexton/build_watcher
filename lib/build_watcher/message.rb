module BuildWatcher
  class Message
    ASCII_STX = "\002"
    ASCII_ETX = "\003"
    ASCII_SEP = "\037"

    class << self
      def project_qty_request
        quantity_request
      end

      # Returns an array of the request which would be generated, as well
      # as the associated response for this request.
      #
      # Only intended for testing purposes!
      def project_qty_request!(number_of_projects_to_return)
        [quantity_request, project_qty_response(number_of_projects_to_return)]
      end

      def project_qty_response(number_of_projects)
        wrap separate("N", number_of_projects)
      end

      def project_info_message(public_key, private_key)
        wrap separate("I", public_key, private_key)
      end

      def project_status(public_key, status)
        unless status && [:nobuilds,:running, :failed, :success].include?(status.to_sym)
          raise ArgumentError, "Invalid status supplied (provided: '#{status}')"
        end
        wrap separate("S", public_key, status.split(//).first)
      end

      private
        def wrap(string)
          "#{ASCII_STX}#{string}#{ASCII_ETX}"
        end

        def separate(*list)
          list.join(ASCII_SEP)
        end

        def quantity_request
          wrap "Q"
        end
    end
  end
end
