# Data Directory

Provide descriptions of any datasets provided with the course or document any
instructions for getting access to the required datasets.

A few notes:

1. Relatively small datasets should be linked from the high level Revolution_Course_Materials/Data directory

```
ln -s ../../../../Data/myfile.csv .
```

will accomplish this on linux

2. Relatively large data sets should *not* go in to this `data` directory. It is not a good idea to include large datasets in the zip file distributed to clients. They should probably be distributed separately. Best practice would be to use a separate BigData directory that is parallel to this current directory.


