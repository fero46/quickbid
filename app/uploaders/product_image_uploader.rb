# encoding: utf-8

class ProductImageUploader < CarrierWave::Uploader::Base
  
  include CarrierWave::RMagick
 
  storage :file
 
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :large do
    process :resize_to_fit => [385,345]
  end

  version :thumb do
    process :resize_to_fill => [85,85]
  end

  version :default do
    process :resize_to_fill => [202, 208]
  end

  version :smaller do 
    process :resize_to_fill => [220, 220]
  end


  def extension_white_list
     %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # 
  def filename
      @name ||= "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  protected
  def secure_token
     var = :"@#{mounted_as}_secure_token"
     model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end
end
