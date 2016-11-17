# Create a JSON service account key here:
#
# https://console.cloud.google.com/apis/credentials/serviceaccountkey
#
# then run with
#
#   GOOGLE_APPLICATION_CREDENTIALS=<file>.json IMG=... ruby google.rb
#
# http://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/VisionV1/VisionService
#
require 'googleauth'
require 'google/apis/vision_v1'
require 'pp'

Vision = Google::Apis::VisionV1 # Alias the module
service = Vision::VisionService.new

scopes = ['https://www.googleapis.com/auth/cloud-platform']
authorization = Google::Auth.get_application_default(scopes)
service.authorization = authorization

content = File.read(ENV['IMG'])
image = Vision::Image.new(content: content)
feature = Vision::Feature.new(type: 'FACE_DETECTION', maxResults: 1)
req = Vision::BatchAnnotateImagesRequest.new(

    requests: [ { image: image,  features: [feature] }] )

# https://cloud.google.com/prediction/docs/reference/v1.6/performance#partial
res = service.annotate_image(req, fields: 'responses(faceAnnotations)')
pp res.to_h

# code to run in terminal
# GOOGLE_APPLICATION_CREDENTIALS="/vagrant/bootcamp/final/lhl_final/faceapp-2b1aa039ea55.json" IMG="/vagrant/bootcamp/final/lhl_final/dunk.jpg" ruby google.rb
