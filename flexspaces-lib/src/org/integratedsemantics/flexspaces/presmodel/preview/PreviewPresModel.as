package org.integratedsemantics.flexspaces.presmodel.preview
{
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.preview.GetPreviewEvent;
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.folder.Node;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.model.vo.PreviewInfoVO;


    /**
     * Presentation model for preview views
     * (with flash preview of doc with zoom, paging, etc. controls)
     * 
     */      
    [Bindable]  
    public class PreviewPresModel extends PresModel
    {
        public var repoNode:IRepoNode;
        
        public var havePreview:Boolean = false;
          
        public var urlFlash:String = "";  
             
		protected var viewResponder:Responder;
		
		
        /**
         * Constructor
         *  
         * @param repoNode  doc node to preview
         * 
         */
        public function PreviewPresModel(repoNode:IRepoNode)
        {
            super();
            
            this.repoNode = repoNode;            
        }
        
        /**
         * Get preview
         *  
         */
        public function getPreview(viewResponder:Responder):void
        {
        	this.viewResponder = viewResponder;
        	
            // use "share" compatible preview if 3.0
            var model:AppModelLocator = AppModelLocator.getInstance();                
        	if (model.ecmServerConfig.serverVersionNum() >= 3.0)
        	{
        	    var node:Node = repoNode as Node;
                var argsNoCache:String = "?c=force&noCacheToken=" + new Date().getTime();        	    
                var url:String = model.ecmServerConfig.urlPrefix + "/api/node/" + node.storeProtocol + "/" + node.storeId + "/" + node.id;
                
                if (model.ecmServerConfig.isLiveCycleContentServices == true)
                {                                
                    url += "/content/thumbnails/webpreview" + argsNoCache + "&ticket=" + model.userInfo.loginTicket;
                }
                else
                {
                    url += "/content/thumbnails/webpreview" + argsNoCache + "&alf_ticket=" + model.userInfo.loginTicket;                    
                }
                this.urlFlash = url;        	
                this.havePreview = true;
                var data:PreviewInfoVO = new PreviewInfoVO();
                data.previewId = node.id;
                data.previewUrl = url;
                viewResponder.result(data);        
        	}
        	else
        	{
                var responder:Responder = new Responder(onResultGetPreview, onFaultGetPreview);
                var getPreviewEvent:GetPreviewEvent = new GetPreviewEvent(GetPreviewEvent.GET_PREVIEW, responder, repoNode);
                getPreviewEvent.dispatch();
            }                    
        }                 
        
        /**
         * Handles return of result from server on getting preview id
         *  
         * @param data preview id, url data
         * 
         */
        protected function onResultGetPreview(data:Object):void
        {
            var result:PreviewInfoVO = data as PreviewInfoVO;
            var previewId:String = result.previewId;
            var previewURL:String =  result.previewUrl;

            if (previewId != null && previewId != "")
            {                
                var model:AppModelLocator = AppModelLocator.getInstance();                
                
                if (model.ecmServerConfig.isLiveCycleContentServices == true)
                {
                    urlFlash = previewURL;                      	
                }   
                else
                {
                    if (model.ecmServerConfig.isLiveCycleContentServices == true)
                    {
                        urlFlash = previewURL + "?ticket=" + model.userInfo.loginTicket;                                                
                    }
                    else
                    {
                        urlFlash = previewURL + "?alf_ticket=" + model.userInfo.loginTicket;                                                
                    }
                }             
                            
                this.havePreview = true;                
            }
            else
            {   
                trace("onGetPreviewComplete no preview");
            }

            viewResponder.result(data);                                                            
        }  
        
        /**
         * Handles return of fault from server on getting preview id
         *   
         * @param info
         * 
         */
        protected function onFaultGetPreview(info:Object):void
        {
            trace("onFaultGetPreview " + info);  
            viewResponder.fault(info);   
        }
    
    }
        
}