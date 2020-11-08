def isStunnableWithPogo():
    # Can Keen stun the enemy with pogo alone?
    return False


def isInvincible():
    # isInvincible. Shots never kill it
    return True

def canRecoverFromStun():
    # recoverFromStun. In case of Keen 9 this is always true and we have the biogarg behavior
    return True


def willNeverStop():
    # willNeverStop. Robo red will continue chasing and shoot wherever required
    return True

