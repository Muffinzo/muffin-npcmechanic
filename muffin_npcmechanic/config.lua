Config = Config or {} --DONT CHANGE

--
--
-- 
--███╗░░██╗░█████╗░████████╗██╗░█████╗░███████╗
--████╗░██║██╔══██╗╚══██╔══╝██║██╔══██╗██╔════╝
--██╔██╗██║██║░░██║░░░██║░░░██║██║░░╚═╝█████╗░░
--██║╚████║██║░░██║░░░██║░░░██║██║░░██╗██╔══╝░░
--██║░╚███║╚█████╔╝░░░██║░░░██║╚█████╔╝███████╗
--╚═╝░░╚══╝░╚════╝░░░░╚═╝░░░╚═╝░╚════╝░╚══════╝
-- 
-- This script is used only for one point - In later updates there will be more points awailable.
-- 
-- 
-- 


Config.fee = 1000

Config.Locations = {
    ["PedInteractionPoint"]      = { coords = vector4(2387.53, 4958.45, 42.58, 177.20), PedModel = "mp_m_waremech_01" }, --change only vector4 and pedmodel
}

Config.Options = {
    [1] = {
        params      = {[1] = { additional = "additional"}},
        position    = 1,
        item        = nil,
        job         = nil,
        label       = "Fix vehicle", -- label for the fixing option
        icon        = "fa fas-clipboard", -- icon for the fixing option
        event       = "muffin:client:startRepair", -- dont change
        type        = "client", -- dont change
    },

}
