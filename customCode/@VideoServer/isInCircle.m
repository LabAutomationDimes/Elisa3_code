function ris = isInCircle(c,r,p)

if norm(p-c)<=r
    ris=1;
else
    ris=0;
end