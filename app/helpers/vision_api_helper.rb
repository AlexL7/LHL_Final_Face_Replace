module VisionApiHelper

  #https://gist.github.com/afeld/655e6e02bf085feb02193f468516fca5
  require 'googleauth'
  require 'google/apis/vision_v1'
  require 'pp'

  def faced
    Vision = Google::Apis::VisionV1 # Alias the module
    service = Vision::VisionService.new

    scopes = ['https://www.googleapis.com/auth/cloud-platform']
    authorization = Google::Auth.get_application_default(scopes)
    service.authorization = authorization

    content = File.read(ENV['IMG'])
    image = Vision::Image.new(content: content)
    feature = Vision::Feature.new(type: 'FACE_DETECTION')
    req = Vision::BatchAnnotateImagesRequest.new(requests: [
      {
       image: image,
        features: [feature]
      }
    ])
    # https://cloud.google.com/prediction/docs/reference/v1.6/performance#partial
    res = service.annotate_image(req, fields: 'responses(faceAnnotations(landmarks))')
    pp res.to_h


  end

end