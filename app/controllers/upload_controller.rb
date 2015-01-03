class UploadController < ApplicationController
  def index

  end

  def new
  end

  def upload
  end

  def create
  	# random string generated to create a new folder name 
    new_folder_name = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
    
    #create the file 
    new_folder_path ="public/uploads/" +new_folder_name 
    FileUtils.mkdir_p(new_folder_path)
    temp_files = []
    size_limit = 1048576
    total_size = 0

    #calculating the size of file
    for fl in params['form']['file']
      total_size = total_size + fl.size
    end
    
    #iterating over the files
    for fl in params['form']['file'] 
      tmp = fl.original_filename
      path = fl.path
      file = File.join("public/uploads/"+new_folder_name, fl.original_filename)
      FileUtils.cp path, file
      temp_files.push(fl.original_filename)      
    end

    # creating zip files 
    require 'zip_file_generator'
    require 'zip'

    directory_to_zip = new_folder_path
    output_file = new_folder_path+ "/" + params['form']['file'][0].original_filename + ".zip"
    zf = ZipFileGenerator.new(directory_to_zip, output_file)
    zf.write()
    for file  in temp_files do 
      File.delete(new_folder_path+"/"+file)
    end

    redirect_to action: "show", id: new_folder_name, fname: output_file

  end

  def show
    @fname = params[:fname]
    @id = params[:id]
    send_file params[:fname]
  end

end
