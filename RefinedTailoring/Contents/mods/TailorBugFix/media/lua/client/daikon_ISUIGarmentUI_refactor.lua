local Diakon = {
    ISGarmentUI = {
        create = ISGarmentUI.create,
        doContextMenu = ISGarmentUI.doContextMenu,
        doPatch = ISGarmentUI.doPatch
    }
}

function ISGarmentUI:doPatch(fabric, thread, needle, part, context, submenu)
    --redesign patching of the clothes
    Diakon.ISGarmentUI.doPatch(self, fabric, thread, needle, part, context, submenu)
    
end
--Need to rewrite the UI as well as recreate some Java Functions.
function ISGarmentUI:doContextMenu(part, x, y)
    Diakon.ISGarmentUI.doContextMenu(self,part,x,y)
    --add code for making my own context menu option myself... Maybe
    ISGarmentUI.instance = self
end



function ISGarmentUI:create()
    Diakon.ISGarmentUI.create(self)
    self:addTextures("Back", "_abdomen", "_abdomen");

    ISGarmentUI.instance = self
end

return Diakon ---> REMEMBER THIS NEEDS TO BE AT THE END OF THE FILE