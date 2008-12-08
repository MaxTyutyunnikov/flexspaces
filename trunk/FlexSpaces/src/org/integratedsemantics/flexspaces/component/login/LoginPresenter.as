package org.integratedsemantics.flexspaces.component.login
{
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	import mx.rpc.Responder;
	
	import org.integratedsemantics.flexspaces.control.event.LoginEvent;
	import org.integratedsemantics.flexspaces.framework.presenter.Presenter;
	import org.integratedsemantics.flexspaces.model.AppModelLocator;
	
	
	/**
	 * Login form for user to login to alfresco server
	 * 
	 * Presenter/Controller of passive view ILoginView views
	 *  
	 */
    public class LoginPresenter extends Presenter
	{		
		/** 
		 * Constructor
		 * 
		 * @param loginView login view to control
		 * 
		 */
		public function LoginPresenter(loginView:ILoginView)
		{
		    super(loginView);
		    
		    if (loginView.view.initialized == true)
		    {
		        onCreationComplete(new Event(""));
	        }
	        else
	        {
                observeCreation(loginView.view, onCreationComplete);            
	        }
		}
		
        /**
         * Getter for the view
         *  
         * @return the view
         * 
         */
        protected function get loginView():ILoginView
        {
            return this.view as ILoginView;            
        }       

		/**
		 * Handle view creation complete 
		 * 
		 * @param creation complete event
		 * 
		 */
		protected function onCreationComplete(event:Event):void
		{			
			var model : AppModelLocator = AppModelLocator.getInstance();                            
			if (model.isLiveCycleContentServices == true)
			{
			    loginView.username.text = "administrator";
			    loginView.password.text = "password"; 
			}
			else
			{
				// Focus the user input box
				loginView.view.focusManager.setFocus(loginView.username);
			}            
			
			// add login btn and enter key handlers
            observeButtonClick(loginView.loginBtn, onLoginButton);                        
            loginView.username.addEventListener(FlexEvent.ENTER, onLoginButton);		 
            loginView.password.addEventListener(FlexEvent.ENTER, onLoginButton);         
		}
	
		/**
		 * Event handler for login button  
		 * 
		 * @param event click event or enter key event
		 */
		protected function onLoginButton(event:Event):void
		{	
			if (loginView.username.text != null && loginView.username.text.length == 0)
			{
				// Remind the user to enter a username
				showErrorMessage("Enter a user name.");
			}
			else
			{
				// Get the password assuring is it now passed as null
				var password:String = loginView.password.text;
				if (password == null)
				{
					password = "";
				}
				
                var responder:Responder = new Responder(onResultLogin, onFaultLogin);
                var loginEvent:LoginEvent = new LoginEvent(LoginEvent.LOGIN, responder, loginView.username.text, password);
                loginEvent.dispatch();				
			}
		}
		
		/**
		 * Login success result handler
		 * 
		 * @param info result
		 */
        protected function onResultLogin(info:Object):void
		{
			// Return the control to its base state
			loginView.username.text = "";
			loginView.password.text = "";
			loginView.errorMessage.text = " ";
		
            var loginDoneEvent:LoginDoneEvent = new LoginDoneEvent(LoginDoneEvent.LOGIN_DONE);
            var dispatched:Boolean = loginView.view.dispatchEvent(loginDoneEvent);                        
		}
		
        /**
         * Login fault handler
         * 
         * @param info result
         */
        protected function onFaultLogin(info:Object):void
        {
            trace("onFaulLogin" + info);            
            // Show the error message
            showErrorMessage(info.type);
        }
		
		/**
		 * Show error message on login form
		 *  
		 * @param message
		 * 
		 */
		protected function showErrorMessage(message:String):void
		{
			// Set the new error message
			loginView.errorMessage.text = message;			
		}
	}	
}