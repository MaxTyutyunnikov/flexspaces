package org.integratedsemantics.flexspacesairmobile.app
{
    import flash.events.Event;
    import flash.net.SharedObject;
    
    import mx.managers.CursorManager;
    import mx.managers.PopUpManager;
    
    import org.integratedsemantics.flexspaces.control.error.ErrorMgr;
    import org.integratedsemantics.flexspaces.control.error.ErrorRaisedEvent;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.global.AppConfig;
    import org.integratedsemantics.flexspaces.model.global.CalaisConfig;
    import org.integratedsemantics.flexspaces.model.global.EcmServerConfig;
    import org.integratedsemantics.flexspaces.model.global.GoogleMapConfig;
    import org.integratedsemantics.flexspaces.model.global.ThumbnailConfig;
    import org.integratedsemantics.flexspaces.presmodel.error.ErrorDialogPresModel;
    import org.integratedsemantics.flexspaces.presmodel.main.FlexSpacesPresModel;
    import org.integratedsemantics.flexspaces.presmodel.search.results.SearchResultsPresModel;
    import org.integratedsemantics.flexspaces.view.error.ErrorDialogView;
    import org.springextensions.actionscript.context.support.FlexXMLApplicationContext;
    
    import spark.components.Application;
        
        
    public class AirMobileAppBase extends Application
    {
        protected var model:AppModelLocator = AppModelLocator.getInstance();
	        
        [Bindable]
        protected var flexSpacesAirPresModel:FlexSpacesPresModel;

        
        public function AirMobileAppBase()
        {
            super();

            // Register interest in the error service events
            ErrorMgr.getInstance().addEventListener(ErrorRaisedEvent.ERROR_RAISED, onErrorRaised);            

            loadConfig();            			                                      
        }

        protected function loadConfig():void
        {
            // spring actionscript config
            model.applicationContext = new FlexXMLApplicationContext("FlexSpacesMobileConfig.xml");
            model.applicationContext.addEventListener(Event.COMPLETE, onApplicationContextComplete);
            model.applicationContext.load();                                          
        }

        protected function onCreationComplete(event:Event):void
        {        	        	        	
        }        
        
        /**
         * Handler called when error is raised when making web script calls
         * 
         * @param event error raised vent
         */
        protected function onErrorRaised(event:ErrorRaisedEvent):void
        {
            if (event.getErrorType() == ErrorMgr.APPLICATION_ERROR)
            {
                CursorManager.removeBusyCursor();
                var msg:String = event.getError().message;
                trace("onErrorRaised: " + msg);
                var errorDialogView:ErrorDialogView = new ErrorDialogView();
                var errorDialogPresModel:ErrorDialogPresModel = new ErrorDialogPresModel(msg, event.getError().getStackTrace() ); 
                errorDialogView.errorDialogPresModel = errorDialogPresModel;
                PopUpManager.addPopUp(errorDialogView, this);                                
            }
        } 
        
        protected function onApplicationContextComplete(event:Event):void
        {
            //trace("onApplicationContextComplete");

            var ecmServerConfig:EcmServerConfig = model.applicationContext.getObject("ecmServerConfig"); 
            
            if (ecmServerConfig.port != null)
            {
                ecmServerConfig.urlPrefix = ecmServerConfig.protocol + "://" + ecmServerConfig.domain + ":" + ecmServerConfig.port + ecmServerConfig.alfrescoUrlPart;
            }
            else
            {
                ecmServerConfig.urlPrefix = ecmServerConfig.protocol + "://" + ecmServerConfig.domain + ecmServerConfig.alfrescoUrlPart;
            }            
            
            model.ecmServerConfig = ecmServerConfig;                

            var appConfig:AppConfig = model.applicationContext.getObject("appConfig"); 
            model.appConfig = appConfig;                

            var calaisConfig:CalaisConfig = model.applicationContext.getObject("calaisConfig"); 
            model.calaisConfig = calaisConfig;                

            var googleMapConfig:GoogleMapConfig = model.applicationContext.getObject("googleMapConfig"); 
            model.googleMapConfig = googleMapConfig;
            
            model.appConfig.airMode = true;         

            var thumbnailConfig:ThumbnailConfig = model.applicationContext.getObject("thumbnailConfig"); 
            model.thumbnailConfig = thumbnailConfig;
            
            flexSpacesAirPresModel = model.applicationContext.getObject("presModel");
            model.flexSpacesPresModel = flexSpacesAirPresModel;            

            // use user prefs if avail
            var userPrefs:SharedObject = SharedObject.getLocal("userPrefs");
            if (userPrefs.data.domain != undefined)
            {
                model.ecmServerConfig.domain = userPrefs.data.domain;
                model.ecmServerConfig.protocol = userPrefs.data.protocol;
                model.ecmServerConfig.port = userPrefs.data.port;            
                model.ecmServerConfig.urlPrefix = userPrefs.data.protocol + "://" 
                    + userPrefs.data.domain + ":" + userPrefs.data.port + model.ecmServerConfig.alfrescoUrlPart;
                
                model.flexSpacesPresModel.showTasks = userPrefs.data.showTasks;

                model.calaisConfig.enableCalais = userPrefs.data.enableCalais;
                model.calaisConfig.calaisKey = userPrefs.data.calaisKey;
                model.googleMapConfig.enableGoogleMap = userPrefs.data.enableGoogleMap;
            }

            if (model.ecmServerConfig.isLiveCycleContentServices == true)
            {
                flexSpacesAirPresModel.showTasks = false;
                flexSpacesAirPresModel.showWCM = false;
            }    
            
            model.configComplete = true;   

            // setup search results
            flexSpacesAirPresModel.searchResultsPresModel = new SearchResultsPresModel();                     

            // setup nav panel after all the config done
            flexSpacesAirPresModel.navPanelPresModel.setupSubViews();                         
        }                
        		
	}
}