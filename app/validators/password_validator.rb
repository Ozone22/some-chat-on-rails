class PasswordValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    unless value =~ /(?=^.{5,}\z)(?=.*[A-Z])(?=.*\d).*\z/
      record.errors[attribute] << (options[:message] || 'wrong pass')
    end
  end
end