import mlx_functions as mlx
from env import *
import time
from selenium.webdriver.common.by import By

def automation(driver): # Automation!

    try:
        driver.get("https://www.scrapethissite.com/pages/") # Go to this website
        print(f'The title of the webpage is: "{driver.title}"\n') # Print the title of the website
        articles = driver.find_elements(By.CLASS_NAME, "page")
        print(f'There are {len(articles)} different articles on this page:\n') # Print how many articles are there
        for i, article in enumerate(articles): # For each article, show us what is the name of the article
             article_text = article.find_element(By.TAG_NAME, "a").text
             print(f"{i+1}. {article_text}")
        print("\nBasic automation finished.\n") # Print that the automation is finished
            
    except Exception as e:
            print(f"Something happened: {e}")
    finally:
        driver.quit()
        mlx.stop_profile(quick_profile_id) # Close browser profile

if __name__ == "__main__":

    token = mlx.signin() # Get MLX token

    try:
        profile_started = False
        while profile_started != True:
            quick_profile_id, quick_profile_port, profile_started, message = mlx.start_quick_profile(token) # Start a quick profile
            if profile_started == True:
                break
            print(f"Profile couldn't be started. Probably downloading core. Will wait for 60 seconds and try again. Here is the message: {message}")
            time.sleep(60)
    except Exception as e:
         print(f"Problem with starting profile: {e}")
        
    driver = mlx.instantiate_driver(quick_profile_port) # Instantiate a webdriver, so we can run automation
    automation(driver) # Start automation
