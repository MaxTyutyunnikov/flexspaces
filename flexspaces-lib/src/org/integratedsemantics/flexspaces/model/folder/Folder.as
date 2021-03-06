package org.integratedsemantics.flexspaces.model.folder
{
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    

    /**
     *  Model for folder view, folderNode and collection of node children
     * 
     */
    public class Folder extends NodeCollection
    {
        // node for the folder itself
        public var folderNode:Node;
        
        // used for current path property
        // note: this ui display path which may be different than repo path
        protected var curPath:String;


        /**
         * Constructor 
         * 
         */
        public function Folder()
        {
            super();
        }
        
        /**
         * Setter of current path of the folder
         *  
         * @param newPath  new path of the folder 
         * 
         */
        public function set currentPath(newPath:String):void
        {
            this.curPath = newPath;
        }
        
        /**
         * Getter of current path of the folder
         *  
         * @return  curent path
         * 
         */
        public function get currentPath():String
        {
            return this.curPath;
        }

        /**
         * Init folder collection with new data
         * 
         * @param data xml data for folder collection
         */
        public function init(data:Object):void
        {
            var result:Folder = data as Folder;
                                         
            var dataPath:String = String(result.folderNode.path);
            
            // trace("Folder init() dataPath " + dataPath + "curPath " + curPath);

            //  when initializing curPath is "/", use company home path we will get back
            if (curPath == "/")
            {
                curPath = dataPath;
            }
            
            var model:AppModelLocator = AppModelLocator.getInstance();

            // only take new data if its for current path of this folder collection
            if ( (model.appConfig.cmisMode == true) || (dataPath == curPath))
            {
                this.totalSize = result.totalSize;
                this.pageSize = result.pageSize;
                this.pageNum = result.pageNum;

                this.folderNode = result.folderNode;
				this.nodeCollection = result.nodeCollection;                
                result.nodeCollection = null;
                
                this.source = nodeCollection.source;
                this.refresh();
            }
        }
        
    }
}