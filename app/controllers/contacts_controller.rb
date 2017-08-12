class ContactsController < ApplicationController
    # GET request to /contact_us
    # Show new contact form
    def new 
        @contact = Contact.new
    end
    
    
    #POST request /contacts
    def create
        # Mass assignment of form fields into Contact object
        @contact = Contact.new(contact_params)
        # Save the contact object to the database
        if @contact.save
            # Store form fields via parameters into variables
            name = params[:contact][:name]
            email = params[:contact][:email]
            body = params[:contact][:comments]
            # Plug variables into the contact mailer email method and email 
            ContactMailer.contact_email(name, email, body).deliver
            # Store success message in flash hash 
            # and redirect to the new action
            flash[:success] = "Message sent."
            redirect_to new_contact_path_url
        else
            # If contact object doesn't save store errors in flash hash
            # and redirect to the new action
            flash[:danger] = @contact.errors.full_messages.join(", ")
            redirect_to new_contact_path_url
        end
    end
    
    private
    # To collect data from form, we need to use strong parameter and white list
    # the form fields 
    def contact_params
        params.require(:contact).permit(:name, :email, :comments)
    end
    
end
