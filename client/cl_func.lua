CLIENT = {
    ClientId = ESX.PlayerData.identifier,
    SelectedId = 0,
    Reports = {},
    Options = {
        { Label = "Question", Description = "Je veux poser une question aux modérateurs en ligne." },
        { Label = "Troll", Description = "Une personne est en train de troll à côté de moi (Conduite HRP, Vocal HRP, FreePunch etc...)." },
        { Label = "Carkill", Description = "Une personne me fonce dessus avec un véhicule pour essayer de me tuer." },
        { Label = "Freekill", Description = "Une personne m'a tué gratuitement sans raison RP." },
        { Label = "Nopain", Description = "Une personne ne simule pas la douleur." },
        { Label = "Nofear", Description = "Une personne ne simule pas la peur." },
        { Label = "PowerGaming", Description = "Une personne réalise des actions impossibles à faire dans la vraie vie." },
        { Label = "MétaGaming", Description = "Une personne utilise des informations qu'il s'est procuré HRP." },
        { Label = "Déconnexion", Description = "Une personne vient de se déconnecter en scène." },
        { Label = "Moddeur", Description = "Une personne utilise un cheat." }
    }
}

function CLIENT:Report(Message)
    TriggerServerEvent("esx_reports:AddReport", Message)
    ESX.ShowNotification("Vous avez envoyé une demande d'assistance aux modérateurs en ligne.")
end

function CLIENT:Action(Action)
    ESX.TriggerServerCallback("esx_reports:Action", function(Success)
        if not Success then
            ESX.ShowNotification("Vous ne pouvez pas faire ça.")
        end
    end, Action, self.Reports[SelectedId])
end

function CLIENT:Teleport(Action)
    ESX.TriggerServerCallback("esx_reports:Teleport", function(Success)
        if not Success then
            ESX.ShowNotification("Le joueur n'est plus connecté au serveur.")
        end
    end, Action, self.Reports[SelectedId].User.source)
end