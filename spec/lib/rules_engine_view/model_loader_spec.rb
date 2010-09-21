require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

# ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

ActiveRecord::Schema.define(:version => 1) do
  create_table :posts do |t|
  end

  create_table :comments do |t|
    t.integer  :post_id  
  end
end

class Post < ActiveRecord::Base
end

class Comment < ActiveRecord::Base
end

describe "model_loader" do
  include RSpec::Rails::ControllerExampleGroup

  controller do
    before_filter do |controller|
      if params[:post_id]
        controller.re_load_model :post, :param_id => :post_id
        if params[:validate]
          controller.re_load_model :comment, :parents => [:post], :validate => params[:validate]
        elsif params[:redirect_path]  
          controller.re_load_model :comment, :parents => [:post], :redirect_path => params[:redirect_path]
        else  
          controller.re_load_model :comment, :parents => [:post]
        end  
      elsif params[:find_by]  
        controller.re_load_model :post, :find_by => params[:find_by]
      elsif params[:param_id]
        controller.re_load_model :post, :param_id => params[:param_id]
      elsif params[:redirect_path]  
        controller.re_load_model :post, :redirect_path => params[:redirect_path]
      else
        controller.re_load_model :post  
      end  
    end
    
    def index
      render :inline => "re_load_model"
    end
    
    def posts_path
      '/posts'      
    end

    def comments_path
      "/comments"
    end
    
    def mock_redirect_path(args = [])
      "/mock_redirect_path/#{args.map(&:id).join('/')}"
    end
  end  

  before(:each) do
    @post = Post.create
    @comment = Comment.create(:post_id => @post.id)
  end
  
  describe "loading a valid model" do
    it "should find the model" do
      Post.should_receive(:send).with(:find, @post.id).and_return(@post)
      get :index, :id => @post.id
    end
        
    it "should set the instance variable '@model'" do
      get :index, :id => @post.id
      assigns(:post).should == @post
    end
  end

  describe "loading an invalid model" do
    it "should set the inastance variable '@model' to nil" do
      get :index, :id => "unknown"
      assigns(:post).should == nil
    end
    
    it "should set the error message" do
      get :index, :id => "unknown"
      flash[:error].should_not be_blank      
    end        
    
    it "should redirect to the index path of the model" do
      get :index, :id => "unknown"
      response.should redirect_to('/posts')
    end   
    
    it "should set the javascript redirect to the index path of the model" do
      xhr :get, :index, :id => "unknown"
      response.body.should == "window.location.href = '\/posts';"
    end
  end

  describe "the model is a child of the direct parent" do
    before(:each) do
      Comment.stub!(:send).with(:find, @comment.id).and_return(@comment)
    end
    
    it "should confirm that this model is a child of the direct parent" do
      @comment.should_receive(:post_id).and_return(@post.id)
      get :index, :id => @comment.id, :post_id => @post.id
      assigns(:post).should == @post
      assigns(:comment).should == @comment
    end
    
    describe "the :validate option" do
      it "should be a valid child if the :validate is true" do
        @comment.should_receive(:validate_method).and_return(true)
        get :index, :id => @comment.id, :post_id => @post.id, :validate => "validate_method"
        assigns(:post).should == @post
        assigns(:comment).should == @comment
      end        

      it "should be a invalid child if the :validate is false" do
        @comment.should_receive(:validate_method).and_return(false)
        get :index, :id => @comment.id, :post_id => @post.id, :validate => "validate_method"
        assigns(:post).should == @post
        assigns(:comment).should == nil
        response.should redirect_to('/comments')
      end              
    end
  end
  
  describe "the model is not a child of the direct parent" do
    before(:each) do
      Comment.stub!(:send).with(:find, @comment.id).and_return(@comment)
      @comment.stub!(:post_id).and_return(-1)
    end
    
    it "should set the inastance variable '@model' to nil" do      
      @comment.should_receive(:post_id).and_return(-1)
      get :index, :id => @comment.id, :post_id => @post.id
      assigns(:post).should == @post
      assigns(:comment).should == nil
    end
  
    it "should set the error message" do
      get :index, :id => @comment.id, :post_id => @post.id
      flash[:error].should_not be_blank
    end        
    
    it "should redirect to the index path of the parent" do
      get :index, :id => @comment.id, :post_id => @post.id
      response.should redirect_to('/comments')
    end        
    
    it "should set the javascript redirect to the path of the parent" do
      xhr :get, :index, :id => @comment.id, :post_id => @post.id
      response.body.should == "window.location.href = '\/comments';"
    end        
  end
  
  describe "finding a model" do
    it "should call find when the parameter :find is not set" do
      Post.should_receive(:send).with(:find, @post.id).and_return(@post)
      get :index, :id => @post.id
    end
    
    it "should use the parameter :find when set" do
      Post.should_receive(:send).with(:find_by_mock, @post.id).and_return(@post)
      get :index, :id => @post.id, :find_by => :find_by_mock
    end
            
    it "should use the parameter :param_id when set" do
      Post.should_receive(:send).with(:find, @post.id).and_return(@post)
      get :index, :test_post_id => @post.id, :param_id => :test_post_id
    end
  
    it "should capture RecordNotFound exceptions and return nil" do
      Post.should_receive(:send).with(:find, @post.id).and_raise(ActiveRecord::RecordNotFound)      
      lambda {
        get :index, :id => @post.id
      }.should_not raise_error
      
      response.should redirect_to('/posts')
    end
  end
  
  describe "redirecting on failure" do
    it "should call the model's index path the parameter :redirect_path is not set" do
      get :index, :id => 'unknown'
      response.should redirect_to('/posts')
    end
    
    it "should use the :redirect_path when set" do
      get :index, :id => 'unknown', :redirect_path => :mock_redirect_path
      response.should redirect_to('/mock_redirect_path/')
    end
        
    it "should pass an array of parent models when the :parents set and :redirect_path set" do
      get :index, :id => 'unknown', :post_id => @post.id, :redirect_path => :mock_redirect_path
      response.should redirect_to("/mock_redirect_path/#{@post.id}")
    end
  end
end