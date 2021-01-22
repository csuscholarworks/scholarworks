class CreatorOrcidValidator < ActiveModel::Validator
  def validate(record)
    return if record.creator_orcid.blank?
    record.errors.add(:base, 'ORCID must be a string of 19 characters, e.g., "0000-0000-0000-0000"') unless self.class.match(record.creator_orcid)
  end

  def self.match(ids)
    ret_val = true
    exp = Regexp.new(orcid_regex)
    ids.each do |id|
      next if id.blank?

      if !exp.match(id)
        ret_val = false
        break;
      end
    end
    ret_val
  end

  def self.orcid_regex
    '^(?<prefix>https?://orcid.org/)?(?<orcid>\d{4}-\d{4}-\d{4}-\d{3}[\dX])/?$'
  end
  private_class_method :orcid_regex
end

