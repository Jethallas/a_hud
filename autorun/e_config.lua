E = {}
E.Config = {}
E.Config.Icon = {}
E.Config.Text = {}
E.Config.Color = {}
E.Config.Ranks = {}

// General Configs
E.Config.DarkRP              = true                  -- Using DarkRP?
E.Config.Second              = true                  -- Show the second bar (HP and Job)
E.Config.Showrank            = true                  -- Show the rank of admins
E.Config.ShowEx              = "health"              -- false = disabled, Use health or armor.
E.Config.Range               = 400                   -- Range of the player card
E.Config.Round               = 2                   -- The main box: 1 = Default , 2 = Square
E.Config.Font                = 1                     -- Text fonts: 1 = Default, 2 = E BIG, 3 = Old School
E.Config.RHide               = "TEAM_ADMIN"               -- Usergroup (E will be deactivatesd for this person)		
										
E.Config.Showwanted  	      = true                  -- Show if a player is wanted
E.Config.Patrol              = "TEAM_ADMIN"          -- Name of the admin class (The E will be deactivated for this class)
E.Config.Wanted              = "Custom Wanted Text"  -- Custom wanted text, set Lang to 4 to use this

E.Config.Icon.Gun            = "gun"                 -- Silkicon for the gun
E.Config.Icon.Paper          = "page"                -- Silkicon for the paper
E.Config.Icon.Warning        = "stop"                -- Silkicon for the warning sign


E.Config.Color.Nametext      = Color(6, 6, 6, 230)
E.Config.Color.Namebg        = Color(255,255,255)
	
E.Config.Color.Jobtext       = Color(255,255,255)
E.Config.Color.Jobbg         = Color(255,255,255)

E.Config.Color.Ranktext      = Color(255,255,255,180)
E.Config.Color.Rankbg        = Color(6, 6, 6, 230)


// Ranks (First color code = Box, Second color code = Text)
E.Config.Ranks["superadmin"] = {"Superadmin", "shield_add", Color(10,10,10,180), Color(255,255,255,180)}
E.Config.Ranks["admin"]      = {"Admin", "shield", Color(10,10,10,180), Color(255,255,255,180)}

