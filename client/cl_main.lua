function CLIENT:Init()

    MainMenu = RageUI.CreateMenu("Assistance", "Demande d'assistance");
    ReportMenu = RageUI.CreateMenu("Assistance", "Liste des demandes");
    ActionMenu = RageUI.CreateSubMenu(ReportMenu, "Assistance", "Actions");

    RegisterCommand("report", function(_, Args, RawCommand)
        if #Args > 0 then
            local Message = RawCommand:sub(8)
            self:Report(Message)
        else
            RageUI.Visible(MainMenu, true)
        end
    end)

    RegisterNetEvent("esx_reports:UpdateReports")
    AddEventHandler("esx_reports:UpdateReports", function(Table)
        self.Reports = Table
    end)

    function RageUI.PoolMenus:CreatorMenu()

        MainMenu:IsVisible(function(Items)
            for _, Option in ipairs(CLIENT.Options) do
                Items:AddButton(Option.Label, Option.Description, { IsDisabled = false }, function(onSelected)
                    if (onSelected) then
                        CLIENT:Report(Option.Label)
                        RageUI.Visible(MainMenu, false)
                    end
                end)
            end
        end, function()
        end)

        ReportMenu:IsVisible(function(Items)

            if json.encode(CLIENT.Reports) == "[]" then
                Items:AddButton("Aucune demande d'assistance en attente", nil, { IsDisabled = false }, function() end)
            else
                for _, Report in pairs(CLIENT.Reports) do
                    local Text = ("Joueur: %s\nMessage: %s"):format(Report.User.name, Report.Message)
                    local Label = Report.Admin == nil and "En attente" or ("En cours par %s"):format(Report.Admin.name)
    
                    Items:AddButton(("Demande n°%s"):format(Report.Id), Text, { IsDisabled = false, RightLabel = Label }, function(onSelected)
                        if (onSelected) then
                            SelectedId = Report.Id
                        end
                    end, ActionMenu)
                end
            end
        end, function()
        end)

        ActionMenu:IsVisible(function(Items)
            local Report = CLIENT.Reports[SelectedId]

            if Report then
                local Text = ("Joueur: %s\nMessage: %s"):format(Report.User.name, Report.Message)
                local Label = Report.Admin == nil and "En attente" or ("En cours par %s"):format(Report.Admin.name)
                local AdminId = Report.Admin and Report.Admin.identifier or nil
                local CanQuitOrDelete = CLIENT.ClientId == AdminId

                Items:AddSeparator("~y~Informations")

                Items:AddButton("Numéro de la demande", Text, { IsDisabled = false, RightLabel = SelectedId }, function() end)
                Items:AddButton("Statut", Text, { IsDisabled = false, RightLabel = Label }, function() end)

                Items:AddSeparator("~y~Actions")

                Items:AddButton("Prendre le report", Text, { IsDisabled = Report.Admin ~= nil }, function(onSelected)
                    if (onSelected) then
                        CLIENT:Action("Take", Report)
                    end
                end)

                Items:AddButton("Quitter le report", Text, { IsDisabled = not CanQuitOrDelete }, function(onSelected)
                    if (onSelected) then
                        CLIENT:Action("Quit", Report)
                    end
                end)

                Items:AddButton("Supprimer le report", Text, { IsDisabled = not CanQuitOrDelete }, function(onSelected)
                    if (onSelected) then
                        CLIENT:Action("Delete", Report)
                    end
                end)

                Items:AddSeparator("~y~Téléportations")

                Items:AddButton("Me téléporter sur le joueur", Text, { IsDisabled = not CanQuitOrDelete }, function(onSelected)
                    if (onSelected) then
                        CLIENT:Teleport("Goto", Report)
                    end
                end)

                Items:AddButton("Téléporter sur le joueur sur moi", Text, { IsDisabled = not CanQuitOrDelete }, function(onSelected)
                    if (onSelected) then
                        CLIENT:Teleport("Bring", Report)
                    end
                end)
            else
                RageUI.GoBack()
            end
        end, function()
        end)
    end

    Keys.Register("F10", "F10", "Menu Administratif (reports)", function()
        ESX.TriggerServerCallback("esx_reports:IsAdmin", function(Boolean)
            if Boolean then
                RageUI.Visible(ReportMenu, not RageUI.Visible(ReportMenu))
            end
        end)
    end)
end

CLIENT:Init()