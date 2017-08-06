module Metrika
  module Api
    module Statistics

      def get_counter_stats(id, params = {})
        params = self.format_params(params)
        raise Metrika::Errors::GeneralError.new("Provide at least metric for query") if params[:metrics].nil?
        self.get("/stat/v1/data", params.merge(id: id))
      end

      # Traffic
      %w( summary deepness hourly load ).each do |report|
        define_method "get_counter_stat_traffic_#{report}" do | id, params = {} |
          params = self.format_params(params)

          self.get(self.send("counter_stat_traffic_#{report}_path"), params.merge(:id => id))
        end

        define_method "counter_stat_traffic_#{report}_path" do
          "/stat/traffic/#{report}"
        end
      end

      # Sources
      %w( summary sites search_engines phrases marketing direct_summary direct_platforms direct_regions tags ).each do |report|
        define_method "get_counter_stat_sources_#{report}" do | id, params = {} |
          params = self.format_params(params)

          self.get(self.send("counter_stat_sources_#{report}_path"), params.merge(:id => id))
        end

        define_method "counter_stat_sources_#{report}_path" do
          "/stat/sources/#{report}"
        end
      end

      # Content
      %w( popular entrance exit titles url_param user_vars ecommerce ).each do |report|
        define_method "get_counter_stat_content_#{report}" do | id, params = {} |
          params = self.format_params(params)

          self.get(self.send("counter_stat_content_#{report}_path"), params.merge(:id => id))
        end

        define_method "counter_stat_content_#{report}_path" do
          "/stat/content/#{report}"
        end
      end

      # Geo
      def get_counter_stat_geo(id, params = {})
        params = self.format_params(params)

        self.get(self.counter_stat_geo_path, params.merge(:id => id))
      end

      def counter_stat_geo_path
        "/stat/geo"
      end

      # Interest
      def get_counter_stat_interest(id, params = {})
        params = self.format_params(params)

        self.get(self.counter_stat_interest_path, params.merge(:id => id))
      end

      def counter_stat_interest_path
        "/stat/interest"
      end

      # Demography
      %w( age_gender structure ).each do |report|
        define_method "get_counter_stat_demography_#{report}" do | id, params = {} |
          params = self.format_params(params)

          self.get(self.send("counter_stat_demography_#{report}_path"), params.merge(:id => id))
        end

        define_method "counter_stat_demography_#{report}_path" do
          "/stat/demography/#{report}"
        end
      end

      # Goals totals
      # https://api-metrika.yandex.ru/stat/v1/data/bytime?date1=2017-01-04&date2=2017-02-03&group=month&metrics=ym:s:goal%3Cgoal_id%3Ereaches&goal_id=16272210&id=24873551&oauth_token=AQAAAAAL0Ht7AAP7dJCGSrvrFkEaii7iEBKOv8Y
      %w(conversionRate userConversionRate users visits reaches).each do |report|
        define_method "get_report_goal_#{report}" do |id, goal_id, filter, params = {}|
          params = self.format_params(params)

          if filter.empty?
            params.update(metrics: "ym:s:goal<goal_id>#{report}",
                          goal_id: goal_id,
                          id: id)
          else
            params.update(filters: "ym:s:trafficSource=='#{filter}'",
                          metrics: "ym:s:goal<goal_id>#{report}",
                          goal_id: goal_id,
                          id: id)
          end

          self.get(stat_path, params)
        end
      end

      # Tech
      %w( browsers os display mobile flash silverlight dotnet java cookies javascript ).each do |report|
        define_method "get_counter_stat_tech_#{report}" do | id, params = {} |
          params = self.format_params(params)

          self.get(self.send("counter_stat_tech_#{report}_path"), params.merge(:id => id))
        end

        define_method "counter_stat_tech_#{report}_path" do
          "/stat/tech/#{report}"
        end
      end

      # Regions
      # https://api-metrika.yandex.ru/stat/v1/data/bytime?date1=2017-01-09&date2=2017-02-09&group=month&dimensions=ym:s:regionCity&ids=15489991&metrics=ym%3As%3Avisits&oauth_token=AQAAAAAL0Ht7AAP7dJCGSrvrFkEaii7iEBKOv8Y
      def get_visits_by_region(id, params = {})
        params = self.format_params(params)

        params.update(dimensions: 'ym:s:regionCity',
                      metrics: 'ym:s:visits',
                      id: id)

        self.get(stat_path, params)
      end

      # Pages
      # https://api-metrika.yandex.ru/stat/v1/data/bytime?date1=2017-01-09&date2=2017-02-09&group=month&preset=popular&dimensions=ym:pv:URLHash&metrics=ym:pv:users&id=15489991&oauth_token=AQAAAAAL0Ht7AAP7dJCGSrvrFkEaii7iEBKOv8Y
      def get_pages_info(id, params = {})
        params = self.format_params(params)

        params.update(dimensions: 'ym:pv:URLHash',
                      metrics: 'ym:pv:users',
                      preset: 'popular',
                      id: id)

        self.get(stat_path, params)
      end

      def stat_path
        '/stat/v1/data/bytime'
      end
    end
  end
end

