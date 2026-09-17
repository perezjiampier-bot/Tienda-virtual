FROM tomcat:9-jre11
# Eliminar la aplicación por defecto de Tomcat para usar la tuya como raíz
RUN rm -rf /usr/local/tomcat/webapps/ROOT
# Copiar todos tus archivos directamente a la carpeta ROOT de Tomcat
COPY . /usr/local/tomcat/webapps/ROOT/
# Exponer el puerto por defecto que usa Render
EXPOSE 8080