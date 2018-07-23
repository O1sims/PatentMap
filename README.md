# Regional Patent Map of Europe

This repository provides a heatmap of European patent applications. A "region" is defined in terms of the [NUTS3](https://en.wikipedia.org/wiki/NUTS_statistical_regions_of_the_United_Kingdom) definition. The objective is to render a set of heatmaps that show patent application activity.

## Data

The data used in this project was collected from the Worldwide Patent Statistical Database, otherwise known as [PATSTAT](https://www.epo.org/searching-for-patents/business/patstat.html#tab-1). This dataset contains bibliographical and legal status patent data from leading industrialised and developing countries. This is extracted from the European Patent Office's databases. The database therefore contains all patents applied for and granted from the 18th Century to the current day.

Although it was impossible to add all data to this repository (in total it is about 400GB), some data was added to the [`data`](/data) directory.

## Images

The objective of this repository is to produce a set of images that highlight the activity of patent applications in each region of Europe over time. The resulting images can be found in the [`images`](/images) directory. For example:

![](./images/patent-map.png "EU Patent Map")

## Contact

The best way to troubleshoot or ask for a new feature or enhancement is to create a Github [issue](https://github.com/O1sims/PatentMap/issues). However, if you have any further questions you can contact [me](mailto:sims.owen@gmail.com) directly.
