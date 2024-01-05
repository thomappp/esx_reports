SERVER = {
    ReportCount = 0,
    Reports = {},
    Texts = {
        Take = "%s a pris en charge la demande d'assistance n°%s.",
        Quit = "%s ne prend plus en charge la demande d'assistance n°%s.",
        Delete = "%s a supprimé la demande d'assistance n°%s."
    }
}

function SERVER:IsAdmin(Player)
    return Player.getGroup() == "admin"
end

function SERVER:CanUse(Player, Action, ReportId)
    if Action == "Take" then
        return self.Reports[ReportId].Admin == nil
    elseif Action == "Quit" or Action == "Delete" then
        local PlayerId = Player.getIdentifier()
        return self.Reports[ReportId].Admin.identifier == PlayerId
    end
end

function SERVER:UpdateReports(Message)
    local Players = ESX.GetExtendedPlayers("group", "admin")

    for _, Player in pairs(Players) do
        Player.showNotification(Message)
        Player.triggerEvent("esx_reports:UpdateReports", self.Reports)
    end
end