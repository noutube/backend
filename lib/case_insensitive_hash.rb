require 'active_support/hash_with_indifferent_access'

# https://stackoverflow.com/a/2030565/3453300
class CaseInsensitiveHash < HashWithIndifferentAccess
  # This method shouldn't need an override, but my tests say otherwise.
  def [](key)
    super convert_key(key)
  end

  protected
    def convert_key(key)
      key.respond_to?(:downcase) ? key.downcase : key
    end
end
