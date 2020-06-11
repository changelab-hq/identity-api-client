require_relative 'mailing'

module IdentityApiClient
  class Mailings < MailingApiBase
    def list(order = 'id')
      resp = client.get_request(route_url("/api/mailings?order=#{order}&api_token=#{client.connection.configuration.options[:api_token]}"))
      if resp.status == 200
        return resp.body.map { |l| IdentityApiClient::Mailing.new(client: client, id: l['id']) }
      else
        false
      end
    end

    def find_by_id(id)
      resp = client.get_request(route_url("/api/mailings/#{id.to_i}?api_token=#{client.connection.configuration.options[:api_token]}"))
      if resp.status == 200
        return IdentityApiClient::Mailing.new(client: client, id: id.to_i)
      else
        false
      end
    end

    def create(mailing_attributes)
      params = {
        'api_token' => client.connection.configuration.options[:api_token],
        'mailing' => mailing_attributes
      }
      resp = client.post_request(route_url('/api/mailings'), params)
      if resp.status < 400
        return IdentityApiClient::Mailing.new(client: client, id: resp.body['id'])
      else
        return resp.body['errors']
      end
    end

    def clone(id)
      params = {
        'api_token' => client.connection.configuration.options[:api_token]
      }
      resp = client.post_request(route_url("/api/mailings/#{id.to_i}/clone"), params)
      if resp.status == 201
        return resp.body['mailing_id']
      else
        false
      end
    end

    def search(query)
      escaped_query = CGI.escape(query)
      resp = client.get_request(route_url("/api/mailings/search?query=#{escaped_query}&api_token=#{client.connection.configuration.options[:api_token]}"))
      if resp.status == 200
        return resp.body.map { |l| IdentityApiClient::Mailing.new(client: client, id: l['id'], name: l['name']) }
      else
        false
      end
    end
  end
end
