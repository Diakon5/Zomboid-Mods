local Diakon = {
    ISGarmentUI = {
        create = ISGarmentUI.create
    }
}

function ISGarmentUI:create()
    Diakon.ISGarmentUI.create(self)
    self:addTextures("Back", "_abdomen", "_abdomen");

    ISGarmentUI.instance = self
end

return Diakon ---> REMEMBER THIS NEEDS TO BE AT THE END OF THE FILE