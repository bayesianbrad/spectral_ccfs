country = {'Kenya'};
city = {'Nairobi'};
parfor ii = 1:length(country)
    classifyimage(country{ii},'S2',city{ii},'on_afrobarometer','training','spec2mat',100,'ccfs/');
    plotlabelled(country{ii},city{ii},'on_afrobarometer', 7,'ccfs/');
end