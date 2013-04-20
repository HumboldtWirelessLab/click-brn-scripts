function y = loadhwdata(fname)
    v = load(fname);
    % sort time
    y = sortrows(v, 8);
end