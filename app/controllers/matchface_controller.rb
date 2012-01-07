require "opencv"
include OpenCV

class MatchfaceController < ApplicationController


  def index
    @result = ""
    if params[:image1].present? and params[:image2].present?
      inst = "#{(Time.current.to_f*10000000).to_i}#{rand(123456)}"
      tmp_dir = "#{Rails.root.to_s}/tmp/#{inst}"
      Dir.mkdir tmp_dir
      pub_dir = "#{Rails.root.to_s}/public/temp/#{inst}"
      Dir.mkdir pub_dir
      @public_dir = "/temp/#{inst}/"
      
      detector = OpenCV::CvHaarClassifierCascade::load "#{Rails.root.to_s}/data/haarcascades/haarcascade_frontalface_alt2.xml"
      
      all_faces = []
      
      [1,2].each do |i|
        img = HTTP.get params[:"image#{i}"], :response => :parsed_body
        f = File.new("#{tmp_dir}/img#{i}", "w+")
        f.binmode
        f.write img
        f.close

        image = OpenCV::IplImage.load "#{tmp_dir}/img#{i}"
        faces = detector.detect_objects(image)
        all_faces.push faces
        faces.each do |face|
          color = OpenCV::CvColor::Blue
          image.rectangle! face.top_left, face.bottom_right, :color => color
        end
        image.save_image "#{pub_dir}/i#{i}.jpg"

      end      
      
      # debugger
      # logger.info 1

    end

  end

end
