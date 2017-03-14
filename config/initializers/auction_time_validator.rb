class AuctionTimeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if (!value.nil?)
      if !record.start.nil?
        record.errors[attribute] << I18n.t('model.errors.custom.before_start') if record.start >= record.end
      end
    end
  end
end