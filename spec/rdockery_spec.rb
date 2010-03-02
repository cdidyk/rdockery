require File.join( File.dirname( __FILE__ ), "/spec_helper" )

module SampleProjects
  def full_project
    './source/full'
  end

  def empty_project
    './source/empty'
  end
end

module Rdockery
  describe Rdockery do
    include SampleProjects

    before :each do
      FileUtils.rm_f Dir.glob("./source/**/megadoc.html")
    end

    context "when creating a megadoc" do
      it "should generate the megadoc" do
        Megadoc.stub!(:new).and_return megadoc = mock(Megadoc, :rdoc_root => full_project)
        megadoc.should_receive(:generate)
        Rdockery.megadoc full_project
      end
    end
  end

  describe Megadoc do
    include SampleProjects

    before :each do
      FileUtils.rm_f Dir.glob("./source/**/megadoc.html")
    end

    context "when generating a megadoc" do
      attr_reader :megadoc

      before :each do
        @megadoc = Megadoc.new full_project
        @megadoc.stub!(:content_from)
      end

      it "should create a new file in the rdoc root directory called 'megadoc.html'" do
        megadoc.generate
        FileTest.should be_file("#{full_project}/megadoc.html")
      end

      it "the megadoc should include all useful content from the project's files directory" do
        megadoc.should_receive(:content_from).with 'files'
        megadoc.generate
      end

      it "the megadoc should include all useful content from the project's classes directory" do
        megadoc.should_receive(:content_from).with 'classes'
        megadoc.generate
      end

      it "the megadoc should have a proper XHTML skeleton" do
        megadoc = Rdockery.megadoc empty_project
        megadoc.contents.should == <<-HERE
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html
     PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
     "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
  <title>Rails Application Document</title>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <link rel="stylesheet" href="app/rdoc-style.css" type="text/css" media="screen" />
</head>
<body>


</body>
</html>
HERE
      end
    end

    context "when getting its contents" do
      it "should get the contents of the generated megadoc.html file" do
        megadoc = Megadoc.new full_project
        megadoc.generate
        megadoc.contents.should == File.read("#{full_project}/megadoc.html")
      end

      it "should return nothing if the megadoc hasn't been generated" do
        Megadoc.new(full_project).contents.should be_nil
      end
    end

    context "when getting the content from an rdoc 'files' directory" do
      attr_reader :doc

      before :each do
        @doc = Hpricot Megadoc.new(full_project).content_from('files')
      end

      it "should get the file header from each html file in the directory" do
        (doc/"div#fileHeader").size.should == 9
      end

      it "should get the body content from each html file in the directory" do
        (doc/"div#bodyContent").size.should == 9
      end

      it "should get the context content from each html file in the directory" do
        (doc/"div#bodyContent > div#contextContent").size.should == 9
      end

      it "should get the section information from each html file in the directory" do
        (doc/"div#section").size.should == 9
      end

      it "should not get XHTML validation links from any of the html files" do
        (doc/"div#validator-badges").size.should == 0
      end
    end

    context "when getting the content from an rdoc 'classes' directory" do
      attr_reader :doc

      before :each do
        @doc = Hpricot Megadoc.new(full_project).content_from('classes')
      end

      it "should get the class header from each html file in the directory" do
        (doc/"div#classHeader").size.should == 6
      end

      it "should get the body content from each html file in the directory" do
        (doc/"div#bodyContent").size.should == 6
      end

      it "should get the context content from each html file in the directory" do
        (doc/"div#bodyContent > div#contextContent").size.should == 6
      end

      it "should get the section content from each html file in the directory" do
        (doc/"div#section").size.should == 6
      end

      it "should not get XHTML validation links from any of the html files" do
        (doc/"div#validator-badges").size.should == 0
      end
    end
  end
end

