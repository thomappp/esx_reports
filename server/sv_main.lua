function SERVER:Init()

    RegisterServerEvent("esx:playerLoaded")
    AddEventHandler("esx:playerLoaded", function(_, Player)
        if self:IsAdmin(Player) then
            Player.triggerEvent("esx_reports:UpdateReports", self.Reports)
        end
    end)

    ESX.RegisterServerCallback("esx_reports:IsAdmin", function(Source, Cb)
        local Player = ESX.GetPlayerFromId(Source)
        local PlayerGroup = Player.getGroup()
        Cb(PlayerGroup == "admin")
    end)

    ESX.RegisterServerCallback("esx_reports:Action", function(Source, Cb, Action, Report)
        local Player = ESX.GetPlayerFromId(Source)
        
        if self:IsAdmin(Player) then
            local ReportId = Report.Id

            if self:CanUse(Player, Action, ReportId) then

                if Action == "Take" then
                    self.Reports[ReportId].Admin = Player
                elseif Action == "Quit" then
                    self.Reports[ReportId].Admin = nil
                elseif Action == "Delete" then
                    self.Reports[ReportId] = nil
                end

                local Message = (self.Texts[Action]):format(Player.getName(), ReportId)
                self:UpdateReports(Message)
                Cb(true)
            else
                Cb(false)
            end
        end
    end)

    ESX.RegisterServerCallback("esx_reports:Teleport", function(Source, Cb, Action, TargetId)
        local Player = ESX.GetPlayerFromId(Source)
        
        if self:IsAdmin(Player) then
            local Target = ESX.GetPlayerFromId(TargetId)
            
            if Target then
                if Action == "Goto" then
                    local Coords = Target.getCoords(true)
                    Player.setCoords(Coords)
                elseif Action == "Bring" then
                    local Coords = Player.getCoords(true)
                    Target.setCoords(Coords)
                end

                Cb(true)
            else
                Cb(false)
            end
        end
    end)

    RegisterServerEvent("esx_reports:AddReport")
    AddEventHandler("esx_reports:AddReport", function(Text)
        local Player = ESX.GetPlayerFromId(source)
        self.ReportCount = self.ReportCount + 1

        self.Reports[self.ReportCount] = {
            Id = self.ReportCount,
            User = Player,
            Message = Text,
            Admin = nil
        }

        self:UpdateReports(("Nouvelle demande d'assistance n°%s."):format(self.ReportCount))
    end)
end

SERVER:Init()
