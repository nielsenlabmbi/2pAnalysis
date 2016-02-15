function correctedAnalyzer = correctAnalyzerFile(Analyzer,removeLastNRepeates,removeFirstNRepeates)
    correctedAnalyzer = Analyzer;
    correctedAnalyzer.L.reps = correctedAnalyzer.L.reps - removeLastNRepeates - removeFirstNRepeates;
    for ii=1:length(correctedAnalyzer.loops.conds)
        correctedAnalyzer.loops.conds{ii}.repeats = correctedAnalyzer.loops.conds{ii}.repeats(removeFirstNRepeates+1:correctedAnalyzer.L.reps+removeFirstNRepeates);
    end
end