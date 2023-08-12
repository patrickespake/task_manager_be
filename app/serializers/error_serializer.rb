# frozen_string_literal: true

class ErrorSerializer
  def initialize(model = nil, custom_errors: [])
    @model = model
    @custom_errors = custom_errors
    @errors_json = { errors: [] }
  end

  def serialized_json
    append_model_errors if @model
    append_custom_errors
    @errors_json[:errors].flatten!
    @errors_json
  end

  private

  def append_model_errors
    @errors_json[:errors] += @model.errors.messages.map { |field, errors| map_errors(field, errors) }
    @errors_json[:errors] << map_associated_errors unless map_associated_errors.empty?
  end

  def append_custom_errors
    @errors_json[:errors] += @custom_errors.map { |error| format_custom_error(error) }
  end

  def map_errors(field, errors)
    errors.map { |error_message| { source: { pointer: "/data/attributes/#{field}" }, detail: error_message.to_s } }
  end

  def format_custom_error(error)
    { source: { pointer: error[:source] }, detail: error[:detail] }
  end

  def map_associated_errors
    @model.class.reflect_on_all_associations.each_with_object([]) do |relationship, errors|
      next if relationship.name == :access_tokens

      append_errors_for_association(relationship, errors)
    end
  end

  def append_errors_for_association(relationship, errors)
    associated_records = Array(@model.public_send(relationship.name))
    associated_records.each_with_index do |child, index|
      child.errors.messages.map do |field, child_errors|
        append_errors_for_child(errors, relationship, field, child_errors, index)
      end
    end
  end

  def append_errors_for_child(errors, relationship, field, child_errors, index)
    child_errors.each do |error_message|
      errors << {
        source: { pointer: "/data/attributes/#{relationship.name}[#{index}].#{field}" },
        detail: error_message.to_s,
      }
    end
  end
end
