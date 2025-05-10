require "sinatra"


#METODOS RUBY
def workshop_content(name)
  File.read("workshops/#{name}.txt") #LEE UN ARCHIVO, LE PASAMOS EL NOMBRE DEL ARCHIVO
rescue Errno:: ENOENT                #RECIBE EL NOMBRE DEL ARCHIVO Y NOSOTROS COMPLETAMOS LA RUTA Y EXTENSION
  return nil #EN CASO NO ENCONTRARA EL ARCHIVO DEVOLVERIA NILL = VACIO
end

def save_workshop(name,description)
  File.open("workshops/#{name}.txt","w") do |file|
    file.print(description)
  end 
end

def delete_workshop(name)
  File.delete("workshops/#{name}.txt")
end

#METODOS HTTP

get '/' do
  @files = Dir.entries("workshops").sort

  erb :home      #llama al metodo erb(definido en sinatra) y le paso como parametro el nombre del archivo sin
                                # la extension, como un simbolo ":"

  #@files.each do |files|
  #  "<a>#{files}</a>"
  #end
end

get '/create' do
  erb :create 
end

get '/:name' do
  @name = params[:name]
  @description = workshop_content(@name)

  erb :workshop
end

get '/:name/edit' do
  @name = params[:name]
  @description = workshop_content(@name)

  erb :edit 
end


post '/create' do
  #@name = params["name"]
  #@description = params["description"] 
  #"<h1>#{@name}</h><p>#{@description}</p>"
  @name = params["name"]
  save_workshop(@name,params["description"])
  @mensaje = "CREADO"
  
  
  erb :message
end

delete '/:name' do
  delete_workshop(params[:name])
  @mensaje = "BORRADO"
  @name = params["name"]
  erb :message
end



put '/:name' do
  @name = params[:name]
  @description = params[:description]
  save_workshop(@name,@description)

  #redirect "/#{@name}"  #PUEDE QUE EL NAVEGADOR NO RECONOZCA LA URL PORQUE TIENE ESPACIOS
  redirect "/#{ERB::Util.url_encode(@name)}" #para volver a codificar el nombre al construir la URL para el navegador por si tiene espacios o caracteres especiales
  
end
  


