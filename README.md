## Functional Gene Marker Analysis Tutorial
This is my first forray into making a bioinformatics tutorial! 

In this tutorial, I will show you how to analyze microbial functional gene sequence data to obtain taxonomic classifications.

Compared to 16S rRNA genes, functional genes can provide better information for a particular microbial trait in the environment. However, it can be quite difficult to classify functional gene sequences to infer taxonomy, due to 1) the lack of curated databases and 2) streamlined pipelines such as for 16S genes.

So, for a beginner who is just starting to get their feet wet with functional gene analysis, this process can feel like an uncomfortable black box (like for me!).

My goal in this short tutorial is to show you how to construct a database of functional genes, which we will then use to classify our sequences to identify their taxonomy. I will do this using several available tools.

### Why the hell am I doing this?
### 1. Make the tutorial that you wish you had! 
Its simple - I wish I had a nice tutorial to guide me when I started. So, for those who don't know where to start - I hope this can help you. I am very much a beginner; I have very little experience in bioinformatics. So part of this is also to encourage any beginner that this stuff isn't difficult to learn! And kind of fun!

### 2. Workflow documentation
Consider this an online lab notebook for myself. I want to insure reproducibility in my own analyses, so putting my analyses in a public repo  will allow me to go back and check my work (as well as for anyone else).

### Objectives
Ok, lets jump straight into it. This tutorial is broken into two parts:

**Part One**: Obtain reference sequences, extract taxonomic information, and build gene database using <a href="https://cran.r-project.org/web/packages/taxize/index.html">Taxise</a> and <a href="https://github.com/geronimp/graftM">graftM</a>

**Part Two**: Classify sequences using graftM
