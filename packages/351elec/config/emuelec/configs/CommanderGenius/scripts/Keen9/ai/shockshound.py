def isInvincible():
    # isInvincible. Shots never kill it
    return True

def canRecoverFromStun():
    return True

def healthPoints():
    # Number of hit points before enemy is stunned
    return 30

def turnAroundOnCliff():
    return False

def endGameOnDefeat():
    # Mortimer can only be defeated if he falls. With that the game ends
    return True
