from redeal import *

def generate_deal(request):
    if request == 'random':
        deal = random_deal()
    elif request == '1nt':
        deal = one_nt()
    elif request == '1s':
        deal = one_spade()
    elif request == '1h':
        deal = one_heart()
    elif request == '1d':
        deal = one_diamond()
    elif request == '2c':
        deal = two_clubs()
    elif request == '2d':
        deal = two_diamonds()
    elif request == '2h':
        deal = two_hearts()
    elif request == '2s':
        deal = two_spades()
    else:
        deal = random_deal()
    
    return deal._long_str()

def random_deal():
    def accept(deal):
        return True
    dealer = Deal.prepare()
    deal = dealer(accept)
    return deal

def one_nt():
    def accept(deal):
        # standard 1NT opening, balanced 15-17
        balanced = [[3,3,3,4], [2,3,4,4], [2,3,3,5]]
        return (deal.north.hcp > 14 and deal.north.hcp < 18 and (sorted(deal.north.shape) in balanced))
    dealer = Deal.prepare()
    deal = dealer(accept)
    return deal

def one_spade():
    def accept(deal):
        return (deal.north.hcp > 11 and len(deal.north.spades) > 4)
    dealer = Deal.prepare()
    deal = dealer(accept)
    return deal

def one_heart():
    def accept(deal):
        return (deal.north.hcp > 11 and len(deal.north.hearts) > 4)
    dealer = Deal.prepare()
    deal = dealer(accept)
    return deal

def one_diamond():
    def accept(deal):
        return (deal.north.hcp > 11 and len(deal.north.diamonds) > 4)
    dealer = Deal.prepare()
    deal = dealer(accept)
    return deal

def two_clubs():
    def accept(deal):
        # Custom 2c showing at least 5-4 in majors, weak
        return (
            deal.north.hcp < 12 
            and deal.north.hcp > 5 
            and (
                (len(deal.north.spades) > 4 and len(deal.north.hearts) > 3)
                or (len(deal.north.spades) > 3 and len(deal.north.hearts) > 4)))
    dealer = Deal.prepare()
    deal = dealer(accept)
    return deal

def two_diamonds():
    def accept(deal):
        # multi, weak 6 card major
        return (deal.north.hcp < 11 and deal.north.hcp > 4 and 
        (len(deal.north.spades) > 5 or len(deal.north.hearts) > 5))
    dealer = Deal.prepare()
    deal = dealer(accept)
    return deal

def two_hearts():
    def accept(deal):
        # Muiderberg, 5+ hearts and 4+ minor, weak 
        return (deal.north.hcp < 11 and deal.north.hcp > 5
        and len(deal.north.hearts) > 4 
        and (len(deal.north.clubs) > 3 or len(deal.north.diamonds) > 3))
    dealer = Deal.prepare()
    deal = dealer(accept)
    return deal

def two_spades():
    def accept(deal):
        # Muiderberg, 5+ spades and 4+ minor, weak 
        return (deal.north.hcp < 11 and deal.north.hcp > 5
        and len(deal.north.spades) > 4 
        and (len(deal.north.clubs) > 3 or len(deal.north.diamonds) > 3))
    dealer = Deal.prepare()
    deal = dealer(accept)
    return deal
