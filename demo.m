d=pwd();
try
  cd code/scripts
  tic;
  run runscript.m
  t=toc;
  fprintf('Demo success! Took %.3g seconds\n',t);
  cd(d)
catch
  cd(d);
end
