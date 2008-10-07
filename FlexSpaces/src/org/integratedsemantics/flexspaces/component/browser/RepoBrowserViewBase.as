package org.integratedsemantics.flexspaces.component.browser
{
    
    import mx.containers.HDividedBox;
    
    import org.integratedsemantics.flexspaces.component.folderview.FolderViewBase;
    import org.integratedsemantics.flexspaces.component.tree.TreeViewBase;
    

    /**
     * Base view class for repository tree/dual folder browser views  
     * 
     */
    public class RepoBrowserViewBase extends HDividedBox
    {
        public var treeView:TreeViewBase;
        public var fileView1:FolderViewBase;
        public var fileView2:FolderViewBase;
        
        /**
         * Constructor 
         */
        public function RepoBrowserViewBase()
        {
            super();
        }        
    }
}