# Spawn the player and a vertical platform in Level 18
whoes = [0x01] 

where = [ [13,85] ]

def spawnForLevel():
    # For which level
    return 18

def howMany():
    # how many foes
    return len(whoes)

def who(idx):
    # Foe id
    return whoes[idx]

def where_x(idx):
    # where will the foe be spawn (x)
    return where[idx][0]

def where_y(idx):
    # where will the foe be spawn (y)
    return where[idx][1]
    

