package org.integratedsemantics.flexspaces.view.folderview.gridview
{
    import flash.events.Event;
    
    import mx.controls.DataGrid;
    import mx.controls.NumericStepper;
    
    import org.integratedsemantics.flexspaces.presmodel.folderview.NodeListViewPresModel;
    import org.integratedsemantics.flexspaces.view.folderview.paging.Pager;
    import org.integratedsemantics.flexspaces.view.folderview.paging.PagerBar;
    
    import spark.components.VGroup;

        
    /**
     * Folder grid base view class 
     * 
     */
    public class FolderGridViewBase extends VGroup
    {
        [Bindable] public var nodeListViewPresModel:NodeListViewPresModel;

        public var folderGrid:DataGrid;
        
        [Bindable]
        public var dataProvider:Object;    
                         
        
        /**
         * Constructor 
         * 
         */
        public function FolderGridViewBase()
        {
            super();
        }

        /**
         * Handle view creation complete 
         * 
         * @param creation complete event
         * 
         */
        protected function onCreationComplete(event:Event):void
        {

        }        

        protected function onChange(event:Event):void
        {
			nodeListViewPresModel.changeSelection(folderGrid.selectedItem, folderGrid.selectedItems);      
        }
                
    }
}