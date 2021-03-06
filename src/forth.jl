literal(i::Int) = @bf [right!, repeated(:inc!, i), right!, inc!]

@bf swap = [step!(-2), dec!, step!(-1), move!(1),
            step!(2), move!(-2),
            step!(-1), move!(1), inc!, step!(2)]

@bf dup = [dec!, step!(-1), move!(1),
           step!(1), move!(-1, 1), inc!,
           step!(2), inc!]

@bf empty! = [[drop], while!]

@bf halt = [[rstack!, Flip(:empty!)], call]

@bf ! = [left!, [right!, dec!, left!, reset!], while!, # Set flag, reset
         right!, [left!, inc!, right!, dec!], while!, inc!]

@bf + = [dec!, left!, move!(-2), left!]
@bf - = [dec!, left!, move!(-2, mode = :dec!), left!]

@bf * = [dec!, step!(-2), dec!, left!, move!(1), right!,
         [dec!, right!, move!(1, -2), right!, move!(-1), step!(-2)], while!,
         right!, reset!, left!, inc!]

@bf < = [left!, move!(-1), left!, dec!, left!, move!(2), right!,
         [right!, right!,
          if!(:pass, @bf [step!(-3), inc!, right!, reset!, step!(2)]),
          left!, dec!, left!, dec!], while!,
         inc!, step!(2), drop]

# End of unsafe operations

@bf != = [-]
@bf == = [-, !]
@bf or = [+]
@bf and = [*]
@bf <= = [[==], [<], bi2, or]
@bf > = [swap, <]
@bf >= = [swap, <=]

@bf sq = [dup, *]

# x f -- x
@bf dip = [swap, rpush, [rpop], rpush, call]
#  x y f -- x y
@bf dip2 = [swap, [dip], dip]

# x y -- y
@bf nip = [swap, drop]
# x y -- x x y
@bf dupd = [[dup], dip]
# x y -- x y x
@bf over = [dupd, swap]
# x y -- x y x y
@bf dup2 = [over, over]
# x y -- y x y
@bf tuck = [swap, over]
# x y z -- x y z x
@bf pick = [[over], dip, swap]
# x y z -- y x z
@bf swapd = [[swap], dip]
# x y z -- y z x
@bf rotl = [swapd, swap]
# x y z -- z x y
@bf rotr = [swap, swapd]

# x f -- x
@bf keep = [dupd, dip]
# x y f -- x y
@bf keep2 = [[dup2], dip, dip2]
# x f g -- fx gx
@bf bi = [[keep], dip, call]
# x y f g -- fxy gxy
@bf bi2 = [[keep2], dip, call]
# x y f g -- fx gy
@bf bi_ = [[dip], dip, call] # bi*
# x y f -- fx fy
@bf bia = [dup, bi_] # bi@

@bf iff = [rotl, [], [swap], if!, drop, call]
@bf when = [[], iff]
@bf unless = [[], swap, iff]

@bf loop = [over, dip2, rotl,
            [dup, dip2, loop], [drop, drop], iff]

@bf doloop = [dup, dip2, loop]
