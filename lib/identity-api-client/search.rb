module IdentityApiClient
  class Search < Base
    attr_accessor :id

    def attributes
      resp = client.get_request("/api/searches/#{id.to_i}?api_token=#{client.connection.configuration.options[:api_token]}")
      if resp.status < 400
        return resp.body
      else
        return resp.body['errors']
      end
    end

    def update(search_attributes)
      params = {
        'api_token' => client.connection.configuration.options[:api_token],
        'search' => search_attributes
      }
      resp = client.put_request("/api/searches/#{id.to_i}", params)
      if resp.status < 400
        return self
      else
        return resp.body['errors']
      end
    end

    def perform(params = {})
      params = { 'api_token' => client.connection.configuration.options[:api_token] }.merge(params)
      resp = client.post_request("/api/searches/#{id.to_i}/perform", params)
      resp.status == 202
    end

    def get_count
      resp = client.get_request("/api/searches/#{id.to_i}/count")
      if resp.status == 200
        return resp.body['total_members']
      else
        false
      end
    end

    def push_to_list(params = {})
      params = { 'api_token' => client.connection.configuration.options[:api_token] }.merge(params)
      resp = client.post_request("/api/searches/#{id.to_i}/push_to_list", params)
      resp.status == 202
    end

    def get_sample_member_ids(params = {})
      params = { 'api_token' => client.connection.configuration.options[:api_token] }.merge(params)
      resp = client.post_request("/api/searches/#{id.to_i}/get_sample_member_ids", params)
      resp.status == 202
    end

    def delete
      params = {
        'api_token' => client.connection.configuration.options[:api_token]
      }
      resp = client.delete_request("/api/searches/#{id.to_i}", params)
      if resp.status < 400
        return self
      else
        return resp.body['errors']
      end
    end
  end
end
