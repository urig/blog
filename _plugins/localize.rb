require 'yaml'

module Jekyll
  class LocalizeTag < Liquid::Tag

    @@translations_cache = {}

    def initialize(tag_name, key, tokens)
      super
      @key = key.strip
    end

    def render(context)
      site = context.registers[:site]
      lang = site.config['lang'] || 'en'
      translations_path = "translations/#{lang}.yaml"
      defaults_path = "translations/defaults.yaml"

      # Load translation file (with caching)
      translations = @@translations_cache[translations_path] ||= load_yaml(translations_path)
      defaults = @@translations_cache[defaults_path] ||= load_yaml(defaults_path)

      result = dig_translation(@key, translations, context)

      # Fallback to default
      if result.nil? && defaults
        result = dig_translation(@key, defaults, context)
      end

      result.to_s
    end

    private

    def load_yaml(path)
      return {} unless File.exist?(path)
      YAML.safe_load(File.read(path), permitted_classes: [Date, Time], aliases: true) || {}
    end

    def dig_translation(key, source, context)
      if key.start_with?('page.')
        tokens = key.split('.')
        tokens.shift # remove 'page'
        data = context['page']
        tokens.each { |token| data = data[token] if data }
        data
      else
        tokens = key.split('.')
        data = source
        tokens.each { |token| data = data[token] if data }
        data
      end
    end
  end
end

Liquid::Template.register_tag('localize', Jekyll::LocalizeTag)
