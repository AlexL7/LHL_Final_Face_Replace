module VisionApiHelper

  #https://gist.github.com/afeld/655e6e02bf085feb02193f468516fca5


  def self.faced
    puts "In faced"

    require 'googleauth'
    require 'google/apis/vision_v1'
    require "google/apis/storage_v1"
    require 'pp'

    vision = Google::Apis::VisionV1 # Alias the module
    service = vision::VisionService.new


    scopes =  ['https://www.googleapis.com/auth/cloud-platform', 'https://www.googleapis.com/auth/devstorage.read_only']
    authorization = Google::Auth.get_application_default(scopes)

    storage = Google::Apis::StorageV1::StorageService.new
    storage.authorization = authorization

    content = File.read("gs://faceimages/dunk.jpg")
    image = vision::Image.new(content: content)
    feature = vision::Feature.new(type: 'FACE_DETECTION')
    req = vision::BatchAnnotateImagesRequest.new(requests: [
      {
       image: image,
        features: [feature]
      }
    ])

    # https://cloud.google.com/prediction/docs/reference/v1.6/performance#partial
    res = service.annotate_image(req, fields: 'responses(faceAnnotations(landmarks))')
    pp res.to_h
    puts res.to_h
        puts "end"
  end

end

VisionApiHelper::faced